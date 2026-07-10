import type { Metadata } from "next";
import { SecureRoutePreview } from "@/components/secure-route-preview";

export const metadata: Metadata = {
  title: "Digital visitor pass",
};

type PassPageProps = {
  params: Promise<{ token: string }>;
};

export default async function PassPage({ params }: PassPageProps) {
  await params;

  return (
    <SecureRoutePreview
      actionLabel="Refresh pass status"
      description="Approved visitors will present a server-validated pass at the entrance without exposing personal information in the URL."
      eyebrow="Digital visitor pass"
      statusDescription="A secure pass reference was detected. The QR code and visit details stay unavailable until backend verification exists."
      statusTitle="Pass preview ready"
      steps={[
        {
          title: "Validate pass",
          description: "The server will verify expiry, revocation, visit state, location, and allowed usage.",
        },
        {
          title: "Display minimum details",
          description: "The page will show only the information needed for visitor and reception verification.",
        },
        {
          title: "Scan at reception",
          description: "Staff will perform the final server-authorized check-in from the Flutter application.",
        },
      ]}
      title="Your visitor pass"
    >
      <div className="feature-grid">
        <article className="feature-card">
          <h2>Pass status</h2>
          <p>Pending secure server validation.</p>
        </article>
        <article className="feature-card">
          <h2>QR verification</h2>
          <p>No QR payload is generated in this foundation milestone.</p>
        </article>
      </div>
    </SecureRoutePreview>
  );
}
