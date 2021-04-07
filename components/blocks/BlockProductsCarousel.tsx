// react
import { useRef } from 'react';

// third-party
import classNames from 'classnames';
import Slick from 'react-slick';

// application
import BlockHeader, { BlockHeaderGroup } from '../shared/BlockHeader';
import ProductCard from '../shared/ProductCard';
import StroykaSlick, { StroykaSlickProps } from '../shared/StroykaSlick';
import { IProduct } from '../../interfaces/product';

function getProductsColumns(products: IProduct[], rows: number) {
    const columns = [];

    if (rows > 0) {
        const productsQueue = products.slice();

        while (productsQueue.length > 0) {
            columns.push(productsQueue.splice(0, rows));
        }
    }

    return columns;
}

export type BlockProductsCarouselLayout = 'grid-4' | 'grid-4-sm' | 'grid-5' | 'horizontal';

export interface BlockProductsCarouselProps<T extends BlockHeaderGroup> {
    title: string;
    layout?: BlockProductsCarouselLayout;
    rows?: number;
    products?: IProduct[];
    groups?: T[];
    withSidebar?: boolean;
    loading?: boolean;
    onGroupClick?: (group: T) => void;
}

const slickSettings: { [layout: string]: StroykaSlickProps } = {
    'grid-4': {
        dots: false,
        arrows: false,
        infinite: true,
        speed: 400,
        slidesToShow: 4,
        slidesToScroll: 4,
        responsive: [
            {
                breakpoint: 992,
                settings: {
                    slidesToShow: 4,
                    slidesToScroll: 4,
                },
            },
            {
                breakpoint: 991,
                settings: {
                    slidesToShow: 3,
                    slidesToScroll: 3,
                },
            },
            {
                breakpoint: 767,
                settings: {
                    slidesToShow: 2,
                    slidesToScroll: 2,
                },
            },
            {
                breakpoint: 479,
                settings: {
                    slidesToShow: 1,
                    slidesToScroll: 1,
                },
            },
        ],
    },
    'grid-4-sm': {
        dots: false,
        arrows: false,
        infinite: true,
        speed: 400,
        slidesToShow: 4,
        slidesToScroll: 4,
        responsive: [
            {
                breakpoint: 1199,
                settings: {
                    slidesToShow: 3,
                    slidesToScroll: 3,
                },
            },
            {
                breakpoint: 767,
                settings: {
                    slidesToShow: 2,
                    slidesToScroll: 2,
                },
            },
            {
                breakpoint: 474,
                settings: {
                    slidesToShow: 1,
                    slidesToScroll: 1,
                },
            },
        ],
    },
    'grid-5': {
        dots: false,
        arrows: false,
        infinite: true,
        speed: 400,
        slidesToShow: 5,
        slidesToScroll: 5,
        responsive: [
            {
                breakpoint: 1199,
                settings: {
                    slidesToShow: 4,
                    slidesToScroll: 4,
                },
            },
            {
                breakpoint: 991,
                settings: {
                    slidesToShow: 3,
                    slidesToScroll: 3,
                },
            },
            {
                breakpoint: 767,
                settings: {
                    slidesToShow: 2,
                    slidesToScroll: 2,
                },
            },
            {
                breakpoint: 479,
                settings: {
                    slidesToShow: 1,
                    slidesToScroll: 1,
                },
            },
        ],
    },
    horizontal: {
        dots: false,
        arrows: false,
        infinite: true,
        speed: 400,
        slidesToShow: 3,
        slidesToScroll: 3,
        responsive: [
            {
                breakpoint: 991,
                settings: {
                    slidesToShow: 2,
                    slidesToScroll: 2,
                },
            },
            {
                breakpoint: 767,
                settings: {
                    slidesToShow: 1,
                    slidesToScroll: 1,
                },
            },
        ],
    },
};

function BlockProductsCarousel<T extends BlockHeaderGroup>(props: BlockProductsCarouselProps<T>) {
    const {
        title,
        layout = 'grid-4',
        rows = 1,
        products = [],
        groups = [],
        withSidebar = false,
        loading = false,
        onGroupClick,
    } = props;
    const slickRef = useRef<Slick>(null);

    const handleNextClick = () => {
        if (slickRef.current) {
            slickRef.current.slickNext();
        }
    };

    const handlePrevClick = () => {
        if (slickRef.current) {
            slickRef.current.slickPrev();
        }
    };

    const columns = getProductsColumns(products, rows).map((column, index) => {
        const products = column.map((product) => (
            <div key={product.id} className="block-products-carousel__cell">
                <ProductCard product={product} />
            </div>
        ));

        return (
            <div key={index} className="block-products-carousel__column">
                {products}
            </div>
        );
    });

    const blockClasses = classNames('block block-products-carousel', {
        'block-products-carousel--loading': loading,
        'block-products-carousel--has-items': columns.length > 0,
    });
    const containerClasses = classNames({
        container: !withSidebar,
    });

    return (
        <div className={blockClasses} data-layout={layout}>
            <div className={containerClasses}>
                <BlockHeader
                    title={title}
                    groups={groups}
                    arrows
                    onNext={handleNextClick}
                    onPrev={handlePrevClick}
                    onGroupClick={onGroupClick}
                />

                <div className="block-products-carousel__slider">
                    <div className="block-products-carousel__preloader" />

                    <StroykaSlick
                        ref={slickRef}
                        {...slickSettings[layout]}
                    >
                        {columns}
                    </StroykaSlick>
                </div>
            </div>
        </div>
    );
}

export default BlockProductsCarousel;
