import "./globals.css";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Azure Global Scale Website",
  description:
    "Globally scalable website fronted by Azure Front Door, WAF and auto-scaling compute."
};

export default function RootLayout({
  children
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className="bg-slate-950 text-slate-100">
        <main className="mx-auto max-w-4xl px-4 py-10">{children}</main>
      </body>
    </html>
  );
}
