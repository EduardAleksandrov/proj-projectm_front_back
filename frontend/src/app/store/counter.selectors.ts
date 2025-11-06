// counter.selectors.ts
import { createSelector } from '@ngrx/store';
import { CounterState } from './counter.reducer';

export const selectCounterState = (state: { counter: CounterState }) => state.counter;

export const selectCount = createSelector(
  selectCounterState,
  (state: CounterState) => state.count
);
