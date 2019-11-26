import { LoginComponent } from './components/login/login.component';
import { RegistrationComponent } from './components/registration/registration.component';
import { RegistrationReceivedComponent } from './components/registration-received/registration-received.component';
import { RegistrationConfirmedComponent } from './components/registration-confirmed/registration-confirmed.component';
import { marker as _ } from '@biesbjerg/ngx-translate-extract-marker';

export const authRoutes = [
	{ path: 'login', component: LoginComponent, data: { title: _('Login') } },
	{ path: 'registration', component: RegistrationComponent, data: { title: _('Register') } },
	{
		path: 'registration/received/:email',
		component: RegistrationReceivedComponent,
		data: { title: _('Registration') }
	},
	{
		path: 'registration/confirmed/:token',
		component: RegistrationConfirmedComponent,
		data: { title: _('Registration Confirmed') }
	}
];
