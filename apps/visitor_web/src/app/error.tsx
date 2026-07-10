"use client";

import { useEffect } from "react";

type ErrorPageProps = {
  error: Error & { digest?: string };
  reset: () => void;
};

export default function ErrorPage({ error, reset }: ErrorPageProps) {
  useEffect(() => {
    console.error("VisitFlow visitor portal rendering error", error);
  }, [error]);

  return (
    <section className="portal-card" aria-labelledby="error-title">
      <div className="portal-card__content">
        <p className="eyebrow">Temporary problem</p>
        <h1 className="hero-title" id="error-title">
          This page could not be loaded safely.
        </h1>
        <p className="hero-copy">
          No visitor action was completed. Try loading the page again, or request a new
          link from the organization if the problem continues.
        </p>
        <div className="action-row">
          <button className="button button--primary" onClick={reset} type="button">
            Try again
          </button>
        </div>
      </div>
    </section>
  );
}
