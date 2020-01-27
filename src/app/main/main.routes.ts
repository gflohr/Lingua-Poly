import { StartComponent } from './components/start/start.component';
import { LegalDisclosureComponent } from './components/legal-disclosure/legal-disclosure.component';
import { DisclaimerComponent } from './components/disclaimer/disclaimer.component';
import { DataPrivacyComponent } from './components/data-privacy/data-privacy.component';
import { marker as _ } from '@biesbjerg/ngx-translate-extract-marker';
import { Routes } from '@angular/router';

export const mainRoutes: Routes = [
	{
		path: '',
		component: StartComponent,
		data: { title: _('Start') }
	},
	{
		path: 'legal-disclosure',
		component: LegalDisclosureComponent,
		data: { title: _('Legal Disclosure') }
	},
	{
		path: 'disclaimer',
		component: DisclaimerComponent,
		data: { title: _('Disclaimer') }
	},
	{
		path: 'data-privacy',
		component: DataPrivacyComponent,
		data: { title: _('Data Privacy') }
	},
	{
		path: ':lingua/mytest',
		component:	StartComponent,
		data: { title: _('Test') }
	},
];
