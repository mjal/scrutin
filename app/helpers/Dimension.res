//import {Dimensions} from 'react-native';
//
//const windowWidth = Dimensions.get('window').width;
//const windowHeight = Dimensions.get('window').height;

%%raw("var Dimensions = require('react-native').Dimensions")

let width = () => %raw("Dimensions.get('window').width")
let height = () => %raw("Dimensions.get('window').height")
