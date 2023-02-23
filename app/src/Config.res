@val external nodeEnv: string = "process.env.NODE_ENV"

let base_url = if nodeEnv == "development" {
  "http://localhost:8080"
  //"https://scrutin-staging.fly.dev"
} else {
  "https://api.scrutin.app"
}

let api_prefix = "/v0"

let api_url = base_url ++ api_prefix