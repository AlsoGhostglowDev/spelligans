package backend;

import flixel.input.keyboard.FlxKey;

class InputFormatter {
    public static function getKeyName(key:FlxKey, ?checkForShifts:Bool = false):String {
        if (key == NONE) return 'NONE';

		var ret = switch (key)
		{
			case ZERO: '0';
			case ONE: '1';
			case TWO: '2';
			case THREE: '3';
			case FOUR: '4';
			case FIVE: '5';
			case SIX: '6';
			case SEVEN: '7';
			case EIGHT: '8';
			case NINE: '9';

			case MINUS: '-';
			case PLUS: '=';
			case LBRACKET: '[' ; case RBRACKET: ']'; 
            case SEMICOLON: ';' ; case QUOTE: "'";
            case COMMA: ',' ; case PERIOD: '.';
            case SLASH: '/' ; case BACKSLASH: '\\';

			case SPACE: ' ';
			
			case ENTER: '';

			case BACKSPACE | SHIFT | CAPSLOCK | TAB | CONTROL: '';
			default:
				key.toString().toLowerCase();
		};

        if (checkForShifts && FlxG.keys.pressed.SHIFT) {
            ret = switch (key) {
				case ZERO: ')';
				case ONE: '!';
				case TWO: '@';
				case THREE: '';
				case FOUR: '$';
				case FIVE: '%';
				case SIX: '^';
				case SEVEN: '&';
				case EIGHT: '*';
				case NINE: '(';

				case MINUS: '_';
				case PLUS: '+';
				case LBRACKET: '{';
				case RBRACKET: '}';
				case SEMICOLON: ':';
				case QUOTE: '"';
				case COMMA: '<';
				case PERIOD: '>';
				case SLASH: '?';
				case BACKSLASH: '|';
                default: ret.toUpperCase();
            }
        }

		return ret;
    } 
}