@val external nodeEnv: string = "process.env.NODE_ENV"

let api_url = if nodeEnv == "development" {
  "http://localhost:8080"
  //"https://scrutin-staging.fly.dev"
} else {
  "https://api.scrutin.app"
}