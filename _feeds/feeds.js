import { GTR } from "https://deno.land/x/gtr/mod.ts";
import { SMTPClient } from "https://deno.land/x/denomailer/mod.ts";

/* const client = new SMTPClient({
  connection: {
    hostname: "smtp.example.com",
    port: 465,
    tls: true,
    auth: {
      username: "example",
      password: "password",
    },
  },
});

await client.send({
  from: "me@example.com",
  to: "you@example.com",
  subject: "example",
  content: "...",
  html: "<p>...</p>",
});

await client.close(); */

const gtr = new GTR();

// Translate text.
const { trans } = await gtr.translate(
  "Your text",
  { targetLang: "zh" },
);

console.log(trans);

// Create speech from text and save to file.
// const result = await gtr.tts("Je parle en français.");

// const data = new Uint8Array(
//   await result.arrayBuffer(),
// );

// await Deno.writeFile("result.mp3", data);