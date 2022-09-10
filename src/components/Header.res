@react.component
let make = () => {
	<Mui.Box
	  display=Mui.Box.Value.string("flex")
	  justifyContent=Mui.Box.Value.string("center")
	  alignItems=Mui.Box.Value.string("center")
	  minHeight=Mui.Box.Value.string("30vh")
	>
		<h1>
      {"Scrutin:"->React.string}
      <br />
      {"end-to-end encrypted"->React.string}
      <br />
      {"verifiable election app"->React.string}
		</h1>
	</Mui.Box>
}
