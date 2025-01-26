export default {
    async email(message, env, ctx) {
  
      try {
        // Send the email to Flask proxy via HTTP
        const response = await fetch(env.PROXY_URL + "/deliver", {
          method: "POST",
          headers: {
            ...message.headers,
            'Content-Type': 'text/plain',
            'X-API-Key': env.API_KEY
          },
          body: message.raw          
        });
  
        if (response.ok) {
          console.log(`Email successfully forwarded to ${to}`);
          return new Response("Email processed successfully", { status: 200 });
        } else {
          console.error(`Failed to forward email: ${await response.text()}`);
          return new Response("Failed to deliver email", { status: 500 });
        }
      } catch (error) {
        console.error("Error:", error);
        return new Response("Internal Server Error", { status: 500 });
      }
    },
  };
  