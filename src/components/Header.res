open Mui; open Helper

@react.component
let make = () => {
	<Box
	  display=boxs("flex")
	  justifyContent=boxs("center")
	  alignItems=boxs("center")
	  minHeight=boxs("30vh")
	>
		<h1>
      {rs("Scrutin:")}
      <br />
      {rs("end-to-end encrypted")}
      <br />
      {rs("verifiable election app")}
		</h1>
	</Box>
}
