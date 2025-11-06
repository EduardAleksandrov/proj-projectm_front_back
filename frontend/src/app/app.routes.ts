import { Routes } from '@angular/router';
import { Root } from './pages/root/root';
import { About } from './pages/about/about';

export const routes: Routes = [
  { path: '',
    component: Root ,
    children: [
      { path: 'about',
        component: About
      }
    ]
  },


];
