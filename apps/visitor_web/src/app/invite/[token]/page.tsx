import type { Metadata } from "next";
import { SecureRoutePreview } from "@/components/secure-route-preview";

export const metadata: Metadata = {
  title: "Invitation confirmation",
};

type InvitationPageProps = {
  params: Promise<{ token: string }>;
};

export default async function InvitationPage({ params }: InvitationPageProps) {
  await params;

  return (
    <SecureRoutePreview
      actionLabel="Confirm attendance"
      description="Invited visitors will review trusted visit details before confirming their attendance."
      eyebrow="Visitor invitation"
      statusDescription="A secure invitation reference was detected. Visit details remain hidden until server validation is implemented."
      statusTitle="Invitation preview ready"
      steps={[
        {
          title: "Validate invitation",
          description: "The server will verify expiry, revocation, organization, location, and allowed use count.",
        },
        {
          title: "Review visit details",
          description: "Only the minimum host, location, schedule, and arrival instructions will be displayed.",
        },
        {
          title: "Confirm or decline",
          description: "The visitor will explicitly accept, decline, or request a correction without creating an account.",
        },
      ]}
      title="Confirm your invitation"
    >
      <div className="feature-grid">
        <article className="feature-card">
          <h2>Host and organization</h2>
          <p>Hidden until the invitation is securely validated.</p>
        </article>
        <article className="feature-card">
          <h2>Date, time, and location</h2>
          <p>Displayed only when the reference is valid and active.</p>
        </article>
      </div>
    </SecureRoutePreview>
  );
}
