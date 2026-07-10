import Link from "next/link";
import type { ReactNode } from "react";

type PublicShellProps = {
  children: ReactNode;
};

export function PublicShell({ children }: PublicShellProps) {
  return (
    <div className="public-shell">
      <a className="skip-link" href="#main-content">
        Skip to main content
      </a>

      <header className="site-header">
        <Link className="brand" href="/" aria-label="VisitFlow visitor portal home">
          <span className="brand-mark" aria-hidden="true">
            <ShieldCheckIcon />
          </span>
          <span>VisitFlow</span>
        </Link>

        <span className="preview-badge">
          <span aria-hidden="true">●</span>
          Foundation preview
        </span>
      </header>

      <main className="page-main" id="main-content">
        {children}
      </main>

      <footer className="site-footer">
        VisitFlow visitor portal · No visitor information is submitted in this preview.
      </footer>
    </div>
  );
}

function ShieldCheckIcon() {
  return (
    <svg
      aria-hidden="true"
      fill="none"
      height="24"
      viewBox="0 0 24 24"
      width="24"
    >
      <path
        d="M12 3 19 6v5c0 4.7-2.8 8-7 10-4.2-2-7-5.3-7-10V6l7-3Z"
        stroke="currentColor"
        strokeLinecap="round"
        strokeLinejoin="round"
        strokeWidth="1.8"
      />
      <path
        d="m9 12 2 2 4-4"
        stroke="currentColor"
        strokeLinecap="round"
        strokeLinejoin="round"
        strokeWidth="1.8"
      />
    </svg>
  );
}
