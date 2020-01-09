import { UrlValidator } from './urlValidator';
import { FormControl } from '@angular/forms';

describe('UrlValidator', () => {
	const schemeTestCases = [
		{
			url: 'http://my.example.fr',
			expected: null,
		},
		{
			url: 'https://my.example.fr',
			expected: null,
		},
		{
			url: 'gopher://my.example.fr',
			expected: 'scheme',
		},
		{
			url: '/path/to/resource',
			expected: 'scheme',
		}
	];

	for (let i = 0; i < schemeTestCases.length; ++i) {
		const tc = schemeTestCases[i];
		const expectation = tc.expected ?
			`'${tc.url}' should cause a ${tc.expected} error`
			: `'${tc.url}' should be okay`;
		let expected = tc.expected ? { [tc.expected]: true } : null;

		it(expectation, () => {
			const c = new FormControl(tc.url);
			expect(UrlValidator.scheme(c)).toEqual(expected);
		});
	}
});
