import * as React from "react"
import Svg, { G, Rect, Path, Defs, ClipPath } from "react-native-svg"
const SvgComponent = () => (
  <Svg xmlns="http://www.w3.org/2000/svg" width={46} height={46} fill="none">
    <G clipPath="url(#a)">
      <Rect width={46} height={46} fill="#6750A4" rx={23} />
      <Path
        fill="#fff"
        d="M21.824 30.658V18h2.148v12.657h-2.148Zm-5.254-5.255v-2.147h12.656v2.147H16.57Z"
      />
    </G>
    <Defs>
      <ClipPath id="a">
        <Rect width={46} height={46} fill="#fff" rx={23} />
      </ClipPath>
    </Defs>
  </Svg>
)
export default SvgComponent

