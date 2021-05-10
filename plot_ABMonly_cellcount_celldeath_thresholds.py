import matplotlib.pyplot as plt

plt.rcParams["figure.figsize"] = [4.1, 3.6 ]
plt.rcParams["figure.dpi"] = 300

SMALL_SIZE = 8
MEDIUM_SIZE = 10
BIGGER_SIZE = 12

plt.rc('font', size=MEDIUM_SIZE)          # controls default text sizes
plt.rc('axes', titlesize=MEDIUM_SIZE )     # fontsize of the axes title
plt.rc('axes', labelsize=MEDIUM_SIZE )    # fontsize of the x and y labels
plt.rc('xtick', labelsize=SMALL_SIZE )    # fontsize of the tick labels
plt.rc('ytick', labelsize=SMALL_SIZE )    # fontsize of the tick labels
plt.rc('legend', fontsize=SMALL_SIZE )    # legend fontsize


parameterSets = [ [1, 23, 17, 21 ] ]  # n=1  sigma_D = 1.0  

exponents = [5]
Nfigs = len(parameterSets) 
labels = [r'$\sigma_D=1$',r'$\sigma_D=1e-5$',r'$\sigma_D=1e-6$',r'$\sigma_D=1e-7$' ]
run = '5'

for j in range( Nfigs ) :

    exp = str( exponents[j] ) 
    parameters = parameterSets[j]

    Nparams = len(parameters) 
    fig, ax = plt.subplots()
    for i in range(Nparams) :

        live = []
        param = str( parameters[i] ) ;
    
        filename =  "./PLOSone_ABM-only-microcarrier/output_parameter"+ param  +"_trial"+ run +".txt"
        with open(filename, 'r' ) as f :
            for line in f :
                if 'Live Cells' in line :
                    live.append( int( line.strip().split(':')[-1] ) )

        Npoints = len( live )
        tsteps = range( Npoints)

        ax.plot(tsteps,live ,  label= labels[i] )


    ax.set_xlim([0, 750])
    ax.set_ylim([5, 500])
    #ax.set_yscale('log')
    plt.ylabel('Cell count', fontsize=10)
    plt.xlabel('Time steps', fontsize=10)
    legend = ax.legend(loc='upper left' )
    plt.savefig("ABMOnly_livecells_celldeath_tresholds_n"+ exp +".png", dpi=150)
