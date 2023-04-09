type t

@new external make: (string) => t = "URL"
@get external pathname: (t) => string = "pathname"
@get external hash: (t) => string = "hash"

@val external _currentHash: string = "window.location.hash"
let getCurrentHash = () => {
  if ReactNative.Platform.os == #web {
    _currentHash
  } else {
    ""
  }
}
@val external _currentHash: string = "window.location.hash"

let arrayToList = a => {
  let rec tolist = (i, res) =>
    if i < 0 {
      res
    } else {
      tolist(i - 1, list{Array.getExn(a, i), ...res})
    }
  tolist(Array.length(a) - 1, list{})
}

let getAndThen = (f) => {
  ReactNative.Linking.getInitialURL()
  -> Promise.thenResolve(res => {
    let sUrl = res -> Js.Null.toOption -> Option.getWithDefault("") -> make -> pathname
    /* remove the preceeding /, which every pathname seems to have */
    let sUrl = Js.String.sliceToEnd(~from=1, sUrl)
    /* remove the trailing /, which some pathnames might have. Ugh */
    let sUrl = switch Js.String.get(sUrl, Js.String.length(sUrl) - 1) {
    | "/" => Js.String.slice(~from=0, ~to_=-1, sUrl)
    | _ => sUrl
    }
    // Transform to a list
    let l = sUrl |> Js.String.split("/") |> Js.Array.filter(item => String.length(item) != 0) |> arrayToList
    // Call callback
    f(l)
  }) -> ignore
}

let _setUrlPathname : (string) => unit = %raw(`function(pathname) { window.history.pushState({}, null, pathname); }`)

let setUrlPathname = (str) => {
  if ReactNative.Platform.os == #web {
    _setUrlPathname(str)
  }
}

%%raw(`
function getParameterByName(name, url = window.location.href) {
    name = name.replace(/[\[\]]/g, '\\$&');
    var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, ' '));
}
`)
// or
// const params = (new URL(location)).searchParams;
// or
// const urlSearchParams = new URLSearchParams(window.location.search);
// const params = Object.fromEntries(urlSearchParams.entries());
let getSearchParameter = (name) => {
  let _name2 = `${name}2`
  let res = %raw(`getParameterByName(name)`)
  res
}

let api_url = switch X.env {
| #dev => "https://scrutin-staging.fly.dev"
| #prod => "https://scrutin-node.fly.dev"
}

let api_url = "http://localhost:8080"
