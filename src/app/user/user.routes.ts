import { marker as _ } from '@biesbjerg/ngx-translate-extract-marker';
import { ProfileComponent } from './components/profile/profile.component';
import { ChangePasswordComponent } from './components/change-password/change-password.component';
import { ResetPasswordComponent } from './components/reset-password/reset-password.component';
import { ChangePasswordWithTokenComponent } from './components/change-password-with-token/change-password-with-token.component';

export const userRoutes = [
	{
		path: 'profile',
		component: ProfileComponent,
		data: { title: _('Profile') }
	},
	{
		path: 'change-password',
		component: ChangePasswordComponent,
		data: { title: _('Change Password') }
	},
	{
		path: 'change-password/:token',
		component: ChangePasswordWithTokenComponent,
		data: { title: _('Change Password') }
	},
	{
		path: 'reset-password',
		component: ResetPasswordComponent,
		data: { title: _('Reset Password') }
	},
];
