// Aspire TypeScript AppHost
// For more information, see: https://aspire.dev

import { createBuilder } from "./.aspire/modules/aspire.mjs";

const builder = await createBuilder();

const api = await builder.addUvicornApp(
  "api",
  "../apps/seneschal/api",
  "main:app",
);

await api.withUv();
await api.withHttpEndpoint({ port: 8000, env: "PORT" });
await api.withHttpHealthCheck({ path: "/health" });

const web = await builder.addViteApp("web", "../apps/seneschal/web");

await web.withPnpm();
await web.withEnvironment("SENESCHAL_API_URL", api.getEndpoint("http"));
await web.withReference(api);
await web.waitFor(api);
await web.withExternalHttpEndpoints();
await web.withHttpEndpoint({ port: 5173 });

await builder.build().run();
