module Link = {
  type props = {href: string, children: React.element};
  
  @module("expo-router")
  external link: React.component<props> = "Link"
  
  let make = (props: props) =>
    React.createElement(link, props)
}
