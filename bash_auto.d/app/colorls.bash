# colorls commodities.

if ! installed colorls; then
	return 0
fi

function ls {
	colorls -G "$@"
}

