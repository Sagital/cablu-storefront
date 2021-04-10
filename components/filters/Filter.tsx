// application
import FilterCategory from './FilterCategory'
import FilterCheck from './FilterCheck'
// import FilterColor from './FilterColor'
import FilterRadio from './FilterRadio'
import FilterRange from './FilterRange'
//import { getFilterValue } from '../../services/filters';
import { ICheckFilterValue, IRadioFilterValue, IRangeFilterValue } from '../../interfaces/filter'
import { IFilter } from '../../types'
import { useState } from 'react'

export interface FilterChangeValueEvent {
  filter: IFilter
  values: string[]
}

export interface FilterProps {
  filter: IFilter
  values: string[]
  onChangeValue: (event: FilterChangeValueEvent) => void
}
//
// const getRangeFilterValue = (data, value): IRangeFilterValue => {
//   return [0, 0]
// }
//
// const getCheckFilterValue = (data, value): ICheckFilterValue => {
//   return ['1', '1']
// }
//
// const getRadioFilterValue = (data, value): IRadioFilterValue => {
//   return '2'
// }

function Filter(props: FilterProps) {
  const { filter, values, onChangeValue } = props

  switch (filter.type) {
    case 'category':
    // return <FilterCategory data={filter} />
    case 'range':
    // return (
    //   <FilterRange
    //     data={data}
    //     value={getRangeFilterValue(data, value)}
    //     onChangeValue={onChangeValue}
    //   />
    // )
    case 'check':
      return <FilterCheck filter={filter} values={values} onChangeValue={onChangeValue} />
    case 'radio':
    // return (
    //   <FilterRadio
    //     filter={filter}
    //     values={values}
    //     value={getRadioFilterValue(data, value)}
    //     onChangeValue={onChangeValue}
    //   />
    // )
    default:
      return null
  }
}

export default Filter
