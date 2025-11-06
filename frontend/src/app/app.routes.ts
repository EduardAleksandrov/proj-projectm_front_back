import { Routes } from '@angular/router';
import { Root } from './pages/root/root';
import { About } from './pages/about/about';
import { Counter } from './pages/counter/counter';

export const routes: Routes = [
  { path: '',
    component: Root ,
    children: [
      { path: 'about',
        component: About
      }
    ]
  },
  { path: 'counter',
    component: Counter ,
  },


];
