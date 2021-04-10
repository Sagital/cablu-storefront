// react
import { ReactNode, useCallback, useEffect, useState } from 'react'

// third-party
import classNames from 'classnames'

// application
import ArrowRoundedDown12x7Svg from '../../svg/arrow-rounded-down-12x7.svg'
import Collapse, { CollapseRenderFn } from '../shared/Collapse'
import Filter, { FilterChangeValueEvent } from '../filters/Filter'
import fetchFromAPI from 'react-storefront/props/fetchFromAPI'
import { ICheckFilter, IRangeFilter, IRangeFilterValue } from '../../interfaces/filter'
import { IFilter } from '../../types'
import { init } from '@graphql-codegen/cli'
import { Category } from '../../saleor/graphql'

// import { serializeFilterValue, isDefaultFilterValue } from '../../services/filters';
// import {
//     useShopFilters,
//     useShopFilterValues,
//     useShopResetFiltersThunk,
//     useShopSetFilterValueThunk,
// } from '../../store/shop/shopHooks';

type WidgetFiltersProps = {
  title?: ReactNode
  category: Category
  filters: IFilter[]
  onFiltersChanged: (filter: IFilter, values: string[]) => {}
  filterValues: { [filter: string]: string[] }
  offcanvas?: 'always' | 'mobile'
}

export interface IFilterValues {
  [filterSlug: string]: string
}

type RenderFilterFn = CollapseRenderFn<HTMLDivElement, HTMLDivElement>

function WidgetFilters(props: WidgetFiltersProps) {
  const { title, offcanvas = 'mobile', category, onFiltersChanged, filterValues } = props

  // useEffect(() => {
  //   const initialValues = props.filters.reduce((acc, f) => {
  //     acc[f.slug] = []
  //     return acc
  //   }, {})
  //
  //   setFilterValues(initialValues)
  // }, [props.filters])

  // const filters: Filter[] = [
  //   // new CategoryFilterBuilder('category', 'Categories'),
  //   {
  //     name: 'aa',
  //     slug: 'a',
  //     type: 'range',
  //     value: [0, 0],
  //     min: 0,
  //     max: 0,
  //   },
  //
  //   {
  //     name: 'bb',
  //     slug: 'b',
  //     type: 'check',
  //     value: ['b'],
  //     items: [{ slug: 'a', name: 'n', count: 1 }],
  //   },
  // ]
  // const values: IFilterValues = {
  //   a: '0',
  //   b: '1',
  // }

  // const shopSetFilterValue = useShopSetFilterValueThunk()
  // const shopResetFilters = useShopResetFiltersThunk()

  const shopSetFilterValue = () => {}
  const shopResetFilters = () => {}
  //const handleValueChange = () => {}

  const handleValueChange = ({ filter, values }: FilterChangeValueEvent) => {
    // setFilterValues(prevState => {
    //   const newValues = { ...prevState, [filter.slug]: values }

    onFiltersChanged(filter, values)
    //
    //   return newValues
    // })

    //
    //     //params[`filter_${slug}`] = filters[slug];
    //
    // fetchFromAPI({})
    //fetch("/api/s/")
  }

  const filtersList = props.filters.map(filter => {
    const renderFilter: RenderFilterFn = ({ toggle, setItemRef, setContentRef }) => (
      <div className="filter filter--opened" ref={setItemRef}>
        <button type="button" className="filter__title" onClick={toggle}>
          {filter.name}
          <ArrowRoundedDown12x7Svg className="filter__arrow" />
        </button>
        <div className="filter__body" ref={setContentRef}>
          <div className="filter__container">
            <Filter
              filter={filter}
              values={(filterValues[filter.slug] as string[]) || []}
              onChangeValue={handleValueChange}
            />
          </div>
        </div>
      </div>
    )

    return (
      <div key={filter.slug} className="widget-filters__item">
        <Collapse toggleClass="filter--opened" render={renderFilter} />
      </div>
    )
  })

  const classes = classNames('widget-filters widget', {
    'widget-filters--offcanvas--always': offcanvas === 'always',
    'widget-filters--offcanvas--mobile': offcanvas === 'mobile',
  })

  return (
    <div className={classes}>
      <h4 className="widget-filters__title widget__title">{title}</h4>

      <div className="widget-filters__list">{filtersList}</div>

      <div className="widget-filters__actions d-flex mb-n2">
        <button type="button" className="btn btn-secondary btn-sm" onClick={shopResetFilters}>
          Reset
        </button>
      </div>
    </div>
  )
}

export default WidgetFilters
