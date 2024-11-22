import * as React from "react"
import Svg, { G, Rect, Path, Defs, ClipPath } from "react-native-svg"
const SvgComponent = () => (
  <Svg xmlns="http://www.w3.org/2000/svg" width={46} height={46} fill="none">
    <G clipPath="url(#a)">
      <Rect width={46} height={46} fill="#6750A4" rx={23} />
      <Path
        fill="#fff"
        d="M28.085 30.296 16.068 18.277l1.62-1.619 12.017 12.017-1.62 1.62Zm-10.398 0-1.619-1.62L28.085 16.66l1.62 1.62-12.017 12.017Z"
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

