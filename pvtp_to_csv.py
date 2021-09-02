from paraview.simple import *
import os
import sys 

paraview.simple._DisableFirstRenderCameraReset()


interval = 1  # This value is obtained from run_model.xml
nsteps = 30000
initialsteps = 0 


DIR = '/home/baguilar/biocellion-user/tissueblock_rbn_ssdiffusion/output'  
#print 'output file  Input ='+DIR    

if  os.path.isdir( DIR ) :

    for STEP in range( initialsteps, nsteps + 1 ) :    

        time =  int( STEP / interval ) 
        print STEP
        myvtu = paraview.simple.XMLPartitionedPolydataReader( FileName=[ DIR + '/agent_'+str(STEP)+'.pvtp'] ) 

        myvtu.PointArrayStatus = ['radius','color', 'State', 'ID' ]

        writer = paraview.simple.CreateWriter( DIR + '/cells.'+str(STEP)+'.csv', myvtu )

        writer.FieldAssociation = "Points"
        writer.Precision = 8
        writer.UpdatePipeline() 


        Delete(myvtu)
       
