// third-party
import classNames from 'classnames';

// application
import Rating13x12Svg from '../../svg/rating-13x12.svg';

export interface RatingProps {
    value?: number;
}

function Rating(props: RatingProps) {
    const { value = 0 } = props;

    const stars = [1, 2, 3, 4, 5].map((rating) => {
        const rootClasses = classNames('rating__star', {
            'rating__star--active': value >= rating,
        });

        return <Rating13x12Svg key={rating} className={rootClasses} />;
    });

    return (
        <div className="rating">
            <div className="rating__body">
                {stars}
            </div>
        </div>
    );
}

export default Rating;
