open ReactNative

@react.component
let make = () => {
	<View>
		<Text>{"Scrutin" -> React.string}</Text>
		<Text>{"end-to-end encrypted" ->  React.string}</Text>
		<Text>{"verifiable election app" -> React.string}</Text>
	</View>
}
