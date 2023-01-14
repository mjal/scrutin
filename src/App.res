// See https://github.com/rescript-react-native/template/blob/main/template/src/App.res for inspiration

open ReactNative

@react.component
let make = () => {
    <SafeAreaView>
        <Text>{"Hello from rescript 3"->React.string}</Text>
    </SafeAreaView>
}