export default function HomePage() {
  return (
    <section className="space-y-4">
      <p className="text-xs font-semibold uppercase tracking-[0.25em] text-sky-400">
        Global traffic • Azure • WAF • CDN
      </p>
      <h1 className="text-3xl font-semibold text-slate-50">
        Globally scalable website on Azure.
      </h1>
      <p className="text-sm text-slate-300 max-w-2xl">
        This site is designed to sit behind Azure Front Door and Application
        Gateway with WAF, backed by auto-scaling compute, a highly available
        managed database, caching and full observability.
      </p>
    </section>
  );
}
