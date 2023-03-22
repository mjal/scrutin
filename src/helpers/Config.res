@val external nodeEnv: string = "process.env.NODE_ENV"

let env = switch nodeEnv {
| "production" => #prod
| "development" => #dev
| _ => #dev
}

let env = #prod

let api_url = switch env {
| #dev  => "http://localhost:8080"
| #prod => "https://scrutin-node.fly.dev"
}
