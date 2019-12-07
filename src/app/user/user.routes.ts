import { marker as _ } from '@biesbjerg/ngx-translate-extract-marker';
import { ProfileComponent } from './components/profile/profile.component';

export const userRoutes = [
	{ path: 'profile', component: ProfileComponent, data: { title: _('Profile') } },
];
