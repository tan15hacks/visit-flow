import type { Metadata, Viewport } from "next";
import type { ReactNode } from "react";
import { PublicShell } from "@/components/public-shell";
import "./globals.css";

export const metadata: Metadata = {
  title: {
    default: "VisitFlow Visitor Portal",
    template: "%s | VisitFlow",
  },
  description:
    "A secure, mobile-first visitor registration and pass experience for VisitFlow organizations.",
  robots: {
    index: false,
    follow: false,
    noarchive: true,
    nosnippet: true,
  },
};

export const viewport: Viewport = {
  colorScheme: "light",
  themeColor: "#175cd3",
};

type RootLayoutProps = Readonly<{
  children: ReactNode;
}>;

export default function RootLayout({ children }: RootLayoutProps) {
  return (
    <html lang="en">
      <body>
        <PublicShell>{children}</PublicShell>
      </body>
    </html>
  );
}
