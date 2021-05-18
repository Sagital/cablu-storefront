import { ICategory } from '../types'

export interface IBaseFilter {
  type: string
  name: string
  slug: string
}
export interface IBaseFilterItem {
  slug: string
  name: string
  count?: number
}
export interface IColorFilterItem extends IBaseFilterItem {
  color: string
}

export type ICategoryFilterValue = string | null
export type IRangeFilterValue = [number, number]
export type ICheckFilterValue = string[]
export type IRadioFilterValue = string | null
export type IColorFilterValue = string[]

export interface ICategoryFilter extends IBaseFilter {
  type: 'category'
  value: ICategoryFilterValue
  items: ICategory[]
}
export interface IRangeFilter extends IBaseFilter {
  type: 'range'
  value: IRangeFilterValue
  min: number
  max: number
}
export interface ICheckFilter extends IBaseFilter {
  type: 'check'
  value: ICheckFilterValue
  items: IBaseFilterItem[]
}
export interface IRadioFilter extends IBaseFilter {
  type: 'radio'
  value: IRadioFilterValue
  values: IBaseFilterItem[]
}
export interface IColorFilter extends IBaseFilter {
  type: 'color'
  value: IColorFilterValue
  items: IColorFilterItem[]
}
