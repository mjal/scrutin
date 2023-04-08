//@react.component
//let make = (~data) => {
//  let colors = ["#ff0000", "#00ff00", "#0000ff"]
//
//  let pieData = Array.mapWithIndex(data, (i, e) => {
//    let color = switch Array.get(colors, i) {
//    | Some(color) => color
//    | None => "#bbbbbb"
//    }
//    PieChart.Datum.make(~value=e, ~key=`pie-${Int.toString(e)}`, ~color)
//  })
//
//  let styles = {
//    open Style
//    StyleSheet.create({
//      "200": viewStyle(
//        ~height=dp(200.0),
//        ()
//      )
//    })
//  }
//
//  <PieChart style=styles["200"] data=pieData />
//}
//
