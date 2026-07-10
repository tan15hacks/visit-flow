import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:visitflow_staff/features/authentication/presentation/auth_session_controller.dart';
import 'package:visitflow_staff/features/organizations/domain/organization_gateway.dart';
import 'package:visitflow_staff/features/organizations/domain/organization_membership.dart';

enum OrganizationAccessStatus {
  preview,
  signedOut,
  loading,
  needsOrganization,
  ready,
  failure,
}

final class OrganizationAccessController extends ChangeNotifier {
  OrganizationAccessController.preview()
    : _gateway = null,
      _authController = null,
      _status = OrganizationAccessStatus.preview;

  OrganizationAccessController({
    required OrganizationGateway gateway,
    required AuthSessionController authController,
  }) : _gateway = gateway,
       _authController = authController,
       _status = authController.isSignedIn
           ? OrganizationAccessStatus.loading
           : OrganizationAccessStatus.signedOut {
    authController.addListener(_handleAuthChanged);
    if (authController.isSignedIn) {
      unawaited(refresh());
    }
  }

  final OrganizationGateway? _gateway;
  final AuthSessionController? _authController;

  OrganizationAccessStatus _status;
  List<OrganizationMembership> _memberships = const [];
  OrganizationMembership? _selectedMembership;
  String? _loadedUserId;
  String? _errorMessage;
  bool _isLoading = false;
  bool _isCreating = false;
  bool _disposed = false;
  int _generation = 0;

  OrganizationAccessStatus get status => _status;
  List<OrganizationMembership> get memberships => _memberships;
  OrganizationMembership? get selectedMembership => _selectedMembership;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  bool get isPreview => _status == OrganizationAccessStatus.preview;
  bool get needsOrganization =>
      _status == OrganizationAccessStatus.needsOrganization;
  bool get isReady => _status == OrganizationAccessStatus.ready;

  Future<void> refresh() async {
    final gateway = _gateway;
    final authController = _authController;
    if (gateway == null || authController == null) {
      return;
    }

    final userId = authController.user?.id;
    if (!authController.isSignedIn || userId == null) {
      _resetForSignedOut();
      return;
    }

    final generation = ++_generation;
    _isLoading = true;
    _errorMessage = null;
    _status = OrganizationAccessStatus.loading;
    _notifySafely();

    try {
      final memberships = await gateway.loadActiveMemberships();
      if (!_isCurrentRequest(generation, userId)) {
        return;
      }
      _memberships = List.unmodifiable(memberships);
      _selectedMembership = memberships.isEmpty ? null : memberships.first;
      _loadedUserId = userId;
      _status = memberships.isEmpty
          ? OrganizationAccessStatus.needsOrganization
          : OrganizationAccessStatus.ready;
    } on OrganizationFailure catch (error) {
      if (!_isCurrentRequest(generation, userId)) {
        return;
      }
      _loadedUserId = userId;
      _errorMessage = error.message;
      _status = OrganizationAccessStatus.failure;
    } on Object {
      if (!_isCurrentRequest(generation, userId)) {
        return;
      }
      _loadedUserId = userId;
      _errorMessage =
          'VisitFlow could not load your organization access. Try again.';
      _status = OrganizationAccessStatus.failure;
    } finally {
      if (generation == _generation && !_disposed) {
        _isLoading = false;
        _notifySafely();
      }
    }
  }

  Future<void> createOrganization({
    required String name,
    required String slug,
    required String timezone,
  }) async {
    final gateway = _gateway;
    final authController = _authController;
    final userId = authController?.user?.id;
    if (gateway == null ||
        authController == null ||
        !authController.isSignedIn ||
        userId == null) {
      _errorMessage = 'Sign in again before creating an organization.';
      _status = OrganizationAccessStatus.failure;
      _notifySafely();
      return;
    }

    _isCreating = true;
    _errorMessage = null;
    _notifySafely();

    try {
      await gateway.createOrganization(
        name: name.trim(),
        slug: slug.trim().toLowerCase(),
        timezone: timezone.trim(),
      );
      await refresh();
    } on OrganizationFailure catch (error) {
      _loadedUserId = userId;
      _errorMessage = error.message;
      _status = OrganizationAccessStatus.needsOrganization;
    } on Object {
      _loadedUserId = userId;
      _errorMessage =
          'Organization setup failed unexpectedly. Check your connection and try again.';
      _status = OrganizationAccessStatus.needsOrganization;
    } finally {
      _isCreating = false;
      _notifySafely();
    }
  }

  void clearError() {
    if (_errorMessage == null) {
      return;
    }
    _errorMessage = null;
    _notifySafely();
  }

  @override
  void dispose() {
    _disposed = true;
    _generation++;
    _authController?.removeListener(_handleAuthChanged);
    super.dispose();
  }

  void _handleAuthChanged() {
    final authController = _authController;
    if (authController == null) {
      return;
    }
    if (!authController.isSignedIn) {
      _resetForSignedOut();
      return;
    }

    final userId = authController.user?.id;
    if (userId != null &&
        userId != _loadedUserId &&
        !_isLoading &&
        !_isCreating) {
      unawaited(refresh());
    }
  }

  void _resetForSignedOut() {
    _generation++;
    _memberships = const [];
    _selectedMembership = null;
    _loadedUserId = null;
    _errorMessage = null;
    _isLoading = false;
    _isCreating = false;
    _status = OrganizationAccessStatus.signedOut;
    _notifySafely();
  }

  bool _isCurrentRequest(int generation, String userId) {
    return !_disposed &&
        generation == _generation &&
        _authController?.user?.id == userId &&
        _authController?.isSignedIn == true;
  }

  void _notifySafely() {
    if (!_disposed) {
      notifyListeners();
    }
  }
}
