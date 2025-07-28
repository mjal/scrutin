  export const config = {
  server: {
    url: process.env.NODE_ENV === 'production' 
      ? 'https://server.scrutin.app' 
      : 'http://127.0.0.1:8080'
  },
  vote: {
    url: process.env.NODE_ENV === 'production' 
      ? 'https://vote.scrutin.app' 
      : 'http://127.0.0.1:19006'
  }
};
