import type { Metadata } from "next";
import { SecureRoutePreview } from "@/components/secure-route-preview";

export const metadata: Metadata = {
  title: "Visitor check-out",
};

type CheckoutPageProps = {
  params: Promise<{ token: string }>;
};

export default async function CheckoutPage({ params }: CheckoutPageProps) {
  await params;

  return (
    <SecureRoutePreview
      actionLabel="Check out"
      description="Organizations may allow an active visitor to end their visit from a secure, time-limited browser link."
      eyebrow="Visitor check-out"
      statusDescription="A secure visit reference was detected. No visit state can be changed until server authorization is implemented."
      statusTitle="Check-out preview ready"
      steps={[
        {
          title: "Validate active visit",
          description: "The server will verify that the visit is checked in, active, and eligible for self check-out.",
        },
        {
          title: "Confirm visitor intent",
          description: "The visitor will review the organization and check-out consequence before continuing.",
        },
        {
          title: "Record the transition",
          description: "The server will atomically update visit status and create an auditable event.",
        },
      ]}
      title="Complete your visit"
    >
      <div className="feature-grid">
        <article className="feature-card">
          <h2>Current visit</h2>
          <p>Visit information remains hidden until the reference is validated.</p>
        </article>
        <article className="feature-card">
          <h2>Check-out status</h2>
          <p>No state transition is available in foundation mode.</p>
        </article>
      </div>
    </SecureRoutePreview>
  );
}
