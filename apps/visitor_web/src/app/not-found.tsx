import Link from "next/link";

export default function NotFoundPage() {
  return (
    <section className="portal-card" aria-labelledby="not-found-title">
      <div className="portal-card__content">
        <p className="eyebrow">Link unavailable</p>
        <h1 className="hero-title" id="not-found-title">
          This visitor link cannot be opened.
        </h1>
        <p className="hero-copy">
          The link may be incomplete, expired, or no longer active. Ask the organization
          or your host to send a new invitation or registration link.
        </p>
        <div className="action-row">
          <Link className="button button--primary" href="/">
            Return to portal
          </Link>
        </div>
      </div>
    </section>
  );
}
