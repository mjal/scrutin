// This is done compile time.
@val external nodeEnv: string = "process.env.NODE_ENV"
let env = switch nodeEnv {
| "production" => #prod
| "development" => #dev
| _ => #dev
}

let base_url = switch env {
| #dev => "http://localhost:19006"
| #prod => "https://scrutin.app"
}

let server_url = switch env {
| #dev => "http://localhost:8080"
| #prod => "https://server.scrutin.app"
}
