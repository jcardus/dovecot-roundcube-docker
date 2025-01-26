export default {
    async email(message, env) {  
      return fetch(env.PROXY_URL + "/deliver", {
        method: "POST",
        headers: {
          'Content-Type': 'text/plain',
          'X-API-Key': env.API_KEY,
          'from': message.from,
          'to': message.to,
        },
        body: message.raw          
      });
    }  
  };
  