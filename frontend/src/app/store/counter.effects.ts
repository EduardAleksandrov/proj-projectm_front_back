// counter.effects.ts
import { Injectable } from '@angular/core';
import { Actions, ofType, createEffect } from '@ngrx/effects';
import { Store } from '@ngrx/store';
import { tap } from 'rxjs/operators';
import { increment } from './counter.actions'; // Import your action

@Injectable()
export class CounterEffects {
  constructor(private actions$: Actions, private store: Store) {}

  logIncrement$ = createEffect(() =>
    this.actions$.pipe(
      ofType(increment),
      tap(action => console.log(`Increment action dispatched: `, action))
    ),
    { dispatch: false } // Set dispatch to false if you're not dispatching another action from this effect
  );
}
