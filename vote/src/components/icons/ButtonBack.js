import * as React from "react"
import Svg, { G, Rect, Path, Defs, ClipPath } from "react-native-svg"

//export default () => {
//  console.log(["Platform", Platform])
//  if (Platform.OS == "web") {
//    return <Image style={{alignSelf: "center", width: 46, height: 46}}
//      source={IconButtonBack} />
//  } else {
//    return <SvgXml xml={xml} width="46" height="46" />
//  }
//}

export default function() {
  return <Svg
    xmlns="http://www.w3.org/2000/svg"
    width={46}
    height={46}
    fill="none"
  >
    <G clipPath="url(#a)">
      <Rect width={46} height={46} fill="#6750A4" rx={23} />
      <Path
        fill="#fff"
        d="m20.338 30-6.364-6.364 6.364-6.363 1.094 1.08-4.503 4.502h11.662v1.563H16.929l4.503 4.488L20.338 30Z"
      />
    </G>
    <Defs>
      <ClipPath id="a">
        <Rect width={46} height={46} fill="#fff" rx={23} />
      </ClipPath>
    </Defs>
  </Svg>
}
