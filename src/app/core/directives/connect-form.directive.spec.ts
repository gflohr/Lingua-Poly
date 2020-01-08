import { ConnectFormDirective } from './connect-form.directive';
import { FormGroupDirective } from '@angular/forms';

describe('ConnectFormDirective', () => {
	it('should create an instance', () => {
		const fgDirective = new FormGroupDirective([], []);
		const directive = new ConnectFormDirective(fgDirective);
		expect(directive).toBeTruthy();
	});
});
