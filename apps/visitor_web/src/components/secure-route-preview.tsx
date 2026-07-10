import type { ReactNode } from "react";

type WorkflowStep = {
  title: string;
  description: string;
};

type SecureRoutePreviewProps = {
  eyebrow: string;
  title: string;
  description: string;
  statusTitle: string;
  statusDescription: string;
  steps: WorkflowStep[];
  actionLabel: string;
  children?: ReactNode;
};

export function SecureRoutePreview({
  eyebrow,
  title,
  description,
  statusTitle,
  statusDescription,
  steps,
  actionLabel,
  children,
}: SecureRoutePreviewProps) {
  return (
    <section className="portal-grid portal-grid--split" aria-labelledby="page-title">
      <article className="portal-card">
        <div className="portal-card__content">
          <p className="eyebrow">{eyebrow}</p>
          <h1 className="hero-title" id="page-title">
            {title}
          </h1>
          <p className="hero-copy">{description}</p>

          <div className="status-panel" role="status">
            <strong>{statusTitle}</strong>
            <p>{statusDescription}</p>
          </div>

          {children}

          <div className="action-row">
            <button className="button button--disabled" disabled type="button">
              {actionLabel}
            </button>
          </div>

          <div className="security-note">
            <span aria-hidden="true">🔒</span>
            <span>
              The secure reference in this URL is never displayed on this page. Backend
              validation and data submission are intentionally disabled in this foundation.
            </span>
          </div>
        </div>
      </article>

      <aside className="portal-card" aria-label="Planned workflow">
        <div className="portal-card__content">
          <p className="eyebrow">Planned workflow</p>
          <ol className="workflow-list">
            {steps.map((step, index) => (
              <li className="workflow-item" key={step.title}>
                <span className="workflow-number" aria-hidden="true">
                  {index + 1}
                </span>
                <div>
                  <h2>{step.title}</h2>
                  <p>{step.description}</p>
                </div>
              </li>
            ))}
          </ol>
        </div>
      </aside>
    </section>
  );
}
