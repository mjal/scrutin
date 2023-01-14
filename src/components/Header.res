open ReactNative
open Helper

@react.component
let make = () => {
	<View>
		<Text>{rs("Scrutin")}</Text>
		<Text>{rs("end-to-end encrypted")}</Text>
		<Text>{rs("verifiable election app")}</Text>
	</View>
}
