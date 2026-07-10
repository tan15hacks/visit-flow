import Link from "next/link";

const portalFeatures = [
  {
    title: "Entrance registration",
    description: "Visitors will open a location-specific form by scanning an entrance QR code.",
  },
  {
    title: "Invitation confirmation",
    description: "Pre-registered guests will review visit details through a time-limited link.",
  },
  {
    title: "Digital visitor pass",
    description: "Approved guests will present a secure pass without exposing personal data in the URL.",
  },
  {
    title: "Self check-out",
    description: "Organizations may allow visitors to end an active visit from their own device.",
  },
];

export default function HomePage() {
  return (
    <section className="portal-grid" aria-labelledby="portal-title">
      <article className="portal-card">
        <div className="portal-card__content">
          <p className="eyebrow">Visitor-facing experience</p>
          <h1 className="hero-title" id="portal-title">
            A simple arrival experience for every visitor.
          </h1>
          <p className="hero-copy">
            VisitFlow will let guests register, confirm invitations, display a pass,
            and check out from a mobile browser. Visitors will not need to install the
            staff application.
          </p>

          <div className="action-row">
            <Link className="button button--primary" href="/register/foundation-preview">
              Preview registration
            </Link>
            <Link className="button button--secondary" href="/invite/foundation-preview">
              Preview invitation
            </Link>
          </div>

          <div className="feature-grid feature-grid--four">
            {portalFeatures.map((feature) => (
              <article className="feature-card" key={feature.title}>
                <h2>{feature.title}</h2>
                <p>{feature.description}</p>
              </article>
            ))}
          </div>
        </div>
      </article>

      <div className="status-panel" role="status">
        <strong>Foundation mode</strong>
        <p>
          These pages contain no live organization, invitation, visitor, or pass data.
          Submission remains disabled until Supabase policies and token validation exist.
        </p>
      </div>
    </section>
  );
}
