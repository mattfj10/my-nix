final: prev: {
  python3 = prev.python3.override {
    packageOverrides = python-final: python-prev: {
      i3ipc = python-prev.buildPythonPackage rec {
        pname = "i3ipc";
        version = "2.2.1";

        src = prev.fetchPypi {
          inherit pname version;
          hash = "sha256-6IDX1xR5WerVyzR2Twi5e0E4WzbrglborxzhY9vMzOg=";
        };

        format = "setuptools";
        doCheck = false;

        # i3ipc imports Xlib in _private/sync.py
        propagatedBuildInputs = with python-prev; [
          xlib
        ];

        pythonImportsCheck = [ "i3ipc" ];

        meta = with prev.lib; {
          description = "Improved Python library to control i3wm and sway";
          homepage = "https://github.com/altdesktop/i3ipc-python";
          license = licenses.bsd3;
          platforms = platforms.linux;
        };
      };
    };
  };
}
