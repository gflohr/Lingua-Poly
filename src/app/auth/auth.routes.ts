import { LoginComponent } from './components/login/login.component';
import { RegistrationComponent } from './components/registration/registration.component';
import { RegistrationReceivedComponent } from './components/registration-received/registration-received.component';
import { RegistrationConfirmedComponent } from './components/registration-confirmed/registration-confirmed.component';

export const authRoutes = [
	{ path: 'login', component: LoginComponent },
	{ path: 'registration', component: RegistrationComponent },
	{
		path: 'registration-received/:email',
		component: RegistrationReceivedComponent
	},
	{
		path: 'registration-confirmed/:token',
		component: RegistrationConfirmedComponent
	}
];
