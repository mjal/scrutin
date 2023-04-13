//@module external bgImg: Image.Source.t = "./logo.png"
@module external bgImg: Image.Source.t = "@expo/snack-static/react-native-logo.png"

@react.component
let make = () => {
  <ImageBackground source=bgImg>
    <Text>{ "Hello world" -> React.string }</Text>
  </ImageBackground>
}
