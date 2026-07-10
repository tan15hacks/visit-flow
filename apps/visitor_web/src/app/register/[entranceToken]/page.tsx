import type { Metadata } from "next";
import { SecureRoutePreview } from "@/components/secure-route-preview";

export const metadata: Metadata = {
  title: "Visitor registration",
};

type RegistrationPageProps = {
  params: Promise<{ entranceToken: string }>;
};

export default async function RegistrationPage({ params }: RegistrationPageProps) {
  await params;

  return (
    <SecureRoutePreview
      actionLabel="Submit registration"
      description="This mobile-first form will collect only the information required by the organization and entrance being visited."
      eyebrow="Entrance registration"
      statusDescription="A secure entrance reference was detected. Organization lookup and submission are not connected yet."
      statusTitle="Registration preview ready"
      steps={[
        {
          title: "Verify entrance",
          description: "The server will validate the opaque entrance reference before returning organization details.",
        },
        {
          title: "Collect minimum details",
          description: "The visitor will provide contact, host, and visit-purpose information required by the organization.",
        },
        {
          title: "Record consent",
          description: "The visitor will review the privacy notice and explicitly consent before submission.",
        },
      ]}
      title="Register your visit"
    >
      <form className="form-preview" aria-label="Visitor registration preview">
        <div className="form-row">
          <div className="field">
            <label htmlFor="visitor-name">Full name</label>
            <input disabled id="visitor-name" placeholder="Visitor name" type="text" />
          </div>
          <div className="field">
            <label htmlFor="visitor-phone">Mobile number</label>
            <input disabled id="visitor-phone" placeholder="Contact number" type="tel" />
          </div>
        </div>
        <div className="form-row">
          <div className="field">
            <label htmlFor="visitor-company">Company or organization</label>
            <input disabled id="visitor-company" placeholder="Optional" type="text" />
          </div>
          <div className="field">
            <label htmlFor="visitor-host">Person or department to visit</label>
            <select disabled id="visitor-host">
              <option>Select a host</option>
            </select>
          </div>
        </div>
        <div className="field">
          <label htmlFor="visit-purpose">Purpose of visit</label>
          <textarea disabled id="visit-purpose" placeholder="Brief visit purpose" />
        </div>
      </form>
    </SecureRoutePreview>
  );
}
