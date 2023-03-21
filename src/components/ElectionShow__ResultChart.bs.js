// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as PieChart from "../helpers/PieChart.bs.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as ReactNative from "react-native";
import * as ReactNativeSvgCharts from "react-native-svg-charts";

function ElectionShow__ResultChart(Props) {
  var data = Props.data;
  var colors = [
    "#ff0000",
    "#00ff00",
    "#0000ff"
  ];
  var pieData = Belt_Array.mapWithIndex(data, (function (i, e) {
          var color = Belt_Array.get(colors, i);
          var color$1 = color !== undefined ? color : "#bbbbbb";
          return PieChart.Datum.make(e, "pie-" + String(e) + "", color$1);
        }));
  var styles = ReactNative.StyleSheet.create({
        "200": {
          height: 200.0
        }
      });
  return React.createElement(ReactNativeSvgCharts.PieChart, {
              data: pieData,
              style: styles[200]
            });
}

var make = ElectionShow__ResultChart;

export {
  make ,
}
/* react Not a pure module */